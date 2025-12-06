
import React from 'react';
import UserProfileDialog from './UserProfileDialog';
import VenueInfoDialog from './VenueInfoDialog';
import AnonymousProfileSetup from './AnonymousProfileSetup';
import AnonymousProfileDialog from './AnonymousProfileDialog';
import SectionWarningModal from './SectionWarningModal';
import AnonymousProfileEditor from './AnonymousProfileEditor';
import { toast } from '@/hooks/use-toast';
import { useNavigate } from 'react-router-dom';

interface MapDialogsProps {
  selectedUser: any;
  setSelectedUser: (user: any) => void;
  selectedVenue: any;
  setSelectedVenue: (venue: any) => void;
  showAnonymousSetup: boolean;
  setShowAnonymousSetup: (show: boolean) => void;
  showAnonymousProfileDialog: boolean;
  setShowAnonymousProfileDialog: (show: boolean) => void;
  showProfileEditor: boolean;
  setShowProfileEditor: (show: boolean) => void;
  setIsAnonymousProfileCreated: (created: boolean) => void;
  setAnonymousMode: (mode: boolean) => void;
}

const MapDialogs: React.FC<MapDialogsProps> = ({
  selectedUser,
  setSelectedUser,
  selectedVenue,
  setSelectedVenue,
  showAnonymousSetup,
  setShowAnonymousSetup,
  showAnonymousProfileDialog,
  setShowAnonymousProfileDialog,
  showProfileEditor,
  setShowProfileEditor,
  setIsAnonymousProfileCreated,
  setAnonymousMode
}) => {
  const navigate = useNavigate();

  const handleViewProfile = (userId: string) => {
    navigate(`/profile/${userId}`);
  };
  
  const handleStartChat = (userId: string) => {
    toast({
      title: "Starting chat",
      description: `Opening conversation with user from NOW`
    });
    navigate(`/messages/${userId}?origin_section=map`);
  };
  
  const handleVenueCheckIn = (venueId: string) => {
    toast({
      title: "Checked In",
      description: `You've checked in at this venue!`
    });
  };

  const handleAnonymousProfileSetup = (data: { name: string; avatar: string }) => {
    setIsAnonymousProfileCreated(true);
    setAnonymousMode(true);
    localStorage.setItem('anonymousProfileCreated', 'true');
    localStorage.setItem('anonymousMode', 'true');
    
    localStorage.setItem('anonymousProfileName', data.name);
    localStorage.setItem('anonymousProfileAvatar', data.avatar);
    
    toast({
      title: "Anonymous Profile Created",
      description: "Your anonymous NOW profile has been created. You are now in anonymous mode.",
    });
    
    setShowProfileEditor(false);
  };

  const handleRequestPrivateAlbum = (userId: string) => {
    toast({
      title: "XXX Album Request",
      description: "Your request has been sent. You'll be notified when access is granted."
    });
  };

  const handleReportProfile = (userId: string) => {
    toast({
      title: "Profile Reported",
      description: "Thank you for your report. Our team will review this profile.",
      variant: "destructive"
    });
  };

  return (
    <>
      <UserProfileDialog
        open={!!selectedUser}
        onOpenChange={(open) => !open && setSelectedUser(null)}
        user={selectedUser}
        onViewProfile={handleViewProfile}
        onStartChat={handleStartChat}
        onRequestPrivateAlbum={handleRequestPrivateAlbum}
        onReportProfile={handleReportProfile}
        blurImages={true}
      />
      
      <VenueInfoDialog 
        open={!!selectedVenue}
        onOpenChange={(open) => !open && setSelectedVenue(null)}
        venue={selectedVenue}
        onCheckIn={handleVenueCheckIn}
      />
      
      <AnonymousProfileSetup
        open={showAnonymousSetup}
        onOpenChange={setShowAnonymousSetup}
        onSetupComplete={handleAnonymousProfileSetup}
      />
      
      <AnonymousProfileDialog
        open={showAnonymousProfileDialog}
        onOpenChange={setShowAnonymousProfileDialog}
        onRegister={() => {}}
      />
      
      <SectionWarningModal 
        onConfirm={() => {
          if (!localStorage.getItem('anonymousProfileCreated')) {
            setShowProfileEditor(true);
          }
        }} 
      />
      
      <AnonymousProfileEditor
        open={showProfileEditor}
        onOpenChange={setShowProfileEditor}
        onSave={handleAnonymousProfileSetup}
      />
    </>
  );
};

export default MapDialogs;
