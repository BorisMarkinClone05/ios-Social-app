/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#ifndef ClouseFriend_CLFMessageType_h
#define ClouseFriend_CLFMessageType_h

typedef enum {
  CLFMessageTypeText  = 0,
  CLFMessageTypePhoto = 1 << 0,
  CLFMessageTypeVideo = 1 << 1,
  CLFMessageTypeAudio = 1 << 2,
  CLFMessageTypeLocation = 1 << 3,
  CLFMessageTypeOther = 1 << 4,
} CLFMessageType;

#endif
