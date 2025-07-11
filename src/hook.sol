// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BaseHook} from "@ecp.eth/protocol/src/hooks/BaseHook.sol";
import {Comments} from "@ecp.eth/protocol/src/types/Comments.sol";
import {IChannelManager} from "@ecp.eth/protocol/src/interfaces/IChannelManager.sol";
import {Metadata} from "@ecp.eth/protocol/src/types/Metadata.sol";
import {Hooks} from "@ecp.eth/protocol/src/types/Hooks.sol";
import {Channels} from "@ecp.eth/protocol/src/types/Channels.sol";

contract OnlyOwnerCanMakeTopLevelCommentsHook is BaseHook {
    error NotOwner();

    address private channelManagerAddress;

    function _onInitialize(
        address channelManager,
        Channels.Channel memory,
        uint256,
        Metadata.MetadataEntry[] calldata
    ) internal override returns (bool) {
        channelManagerAddress = channelManager;
        return true;
    }

    function _onCommentAdd(
        Comments.Comment calldata commentData,
        Metadata.MetadataEntry[] calldata,
        address,
        bytes32
    ) internal view override returns (Metadata.MetadataEntry[] memory) {
        IChannelManager channelManager = IChannelManager(channelManagerAddress);
        address owner = channelManager.ownerOf(commentData.channelId);
        // Only gate comments, not reactions
        if (
            commentData.commentType == Comments.COMMENT_TYPE_COMMENT &&
            commentData.parentId == 0 &&
            commentData.author != owner
        ) {
            revert NotOwner();
        }
        return new Metadata.MetadataEntry[](0);
    }

    function _getHookPermissions()
        internal
        pure
        override
        returns (Hooks.Permissions memory)
    {
        return
            Hooks.Permissions({
                onInitialize: true,
                onCommentAdd: true,
                onCommentDelete: false,
                onCommentEdit: false,
                onChannelUpdate: false,
                onCommentHookDataUpdate: false
            });
    }
}
