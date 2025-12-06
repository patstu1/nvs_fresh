
export function useRoomMetadata(roomType: 'local' | 'city' | 'forum' = 'city') {
  // Get room subtitle based on type
  const getRoomSubtitle = () => {
    switch (roomType) {
      case 'local':
        return "Local proximity room";
      case 'forum':
        return "Discussion forum";
      default:
        return "City room";
    }
  };

  return {
    getRoomSubtitle
  };
}
