
import { toast } from '@/hooks/use-toast';

export const useProfileNotifications = () => {
  const handleBlockNotification = (name: string, isBlocked: boolean) => {
    toast({
      title: isBlocked ? "User Unblocked" : "User Blocked",
      description: isBlocked ? `${name} has been unblocked` : `${name} has been blocked`,
    });
  };

  const handleReportNotification = () => {
    toast({
      title: "Report User",
      description: "User reported to moderation",
    });
  };

  const handleLocationChange = (city: { name: string; country: string }) => {
    toast({
      title: "Virtual Location Changed",
      description: `You're now browsing from ${city.name}, ${city.country}`,
    });
  };

  const handlePrivateAlbumRequest = (name: string) => {
    toast({
      title: "Request Sent",
      description: `${name} will be notified about your album request`,
    });
  };

  return {
    handleBlockNotification,
    handleReportNotification,
    handleLocationChange,
    handlePrivateAlbumRequest,
  };
};
