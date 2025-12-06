
import React, { useState } from 'react';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { toast } from '@/hooks/use-toast';
import { useAuth } from '@/hooks/useAuth';
import { Button } from '@/components/ui/button';
import { useNavigate } from 'react-router-dom';
import { Image } from 'lucide-react';
import BasicInfoTab from '@/components/edit-profile/tabs/BasicInfoTab';
import StatsTab from '@/components/edit-profile/tabs/StatsTab';
import Header from '@/components/edit-profile/Header';
import IdentityTab from '@/components/edit-profile/tabs/IdentityTab';
import HealthTab from '@/components/edit-profile/tabs/HealthTab';

const EditProfile = () => {
  const { user } = useAuth();
  const navigate = useNavigate();
  
  const userProfile = {
    username: user?.email?.split('@')[0] || "User",
    avatar_url: "",
    isOnline: true,
    displayName: "",
    aboutMe: ""
  };
  
  const [showAge, setShowAge] = useState(true);
  const [profileDetails, setProfileDetails] = useState({
    displayName: 'P',
    age: 39,
    height: "6'0\"",
    weight: "175 lb",
    bodyType: "Athletic",
    position: "Vers Top",
    ethnicity: "White",
    relationshipStatus: "Single",
    lookingFor: "Dates, Hookups",
    meetAt: "My Place",
    acceptsNSFW: true,
    aboutMe: "Tell people who you are and what you're looking for (not what you're not looking for)",
    tags: []
  });
  
  const [socialLinks, setSocialLinks] = useState({
    instagram: "username",
    twitter: "",
    facebook: "",
    spotify: ""
  });
  
  const [healthInfo, setHealthInfo] = useState({
    hivStatus: "Negative, on PrEP",
    lastTestedDate: "January 2024",
    testingReminders: false,
    vaccinations: ["COVID-19", "Monkeypox", "Meningitis"]
  });
  
  const [selectedTribes, setSelectedTribes] = useState(['Discreet', 'Jock', 'Leather']);
  
  const updateProfile = () => {
    toast({
      title: "Profile updated",
      description: "Your profile has been successfully updated",
    });
  };

  const navigateToMediaManager = () => {
    navigate('/media-manager');
  };

  return (
    <div className="min-h-screen bg-black text-white pb-20">
      <Header onSave={updateProfile} />
      
      <div className="pt-20 px-4 mb-6">
        <Button
          onClick={navigateToMediaManager}
          className="w-full bg-[#E6FFF4] text-black hover:bg-[#E6FFF4]/90 flex items-center justify-center"
        >
          <Image className="mr-2 h-5 w-5" />
          Manage Photos & Albums
        </Button>
      </div>
      
      <Tabs defaultValue="basic" className="">
        <TabsList className="bg-[#121212] w-full rounded-none border-b border-white/10 h-12">
          <TabsTrigger value="basic" className="flex-1 data-[state=active]:text-[#AAFF50]">Basic</TabsTrigger>
          <TabsTrigger value="stats" className="flex-1 data-[state=active]:text-[#AAFF50]">Stats</TabsTrigger>
          <TabsTrigger value="identity" className="flex-1 data-[state=active]:text-[#AAFF50]">Identity</TabsTrigger>
          <TabsTrigger value="health" className="flex-1 data-[state=active]:text-[#AAFF50]">Health</TabsTrigger>
        </TabsList>
        
        <TabsContent value="basic">
          <BasicInfoTab 
            userProfile={userProfile}
            profileDetails={profileDetails}
            selectedTribes={selectedTribes}
            setProfileDetails={setProfileDetails}
            setSelectedTribes={setSelectedTribes}
          />
        </TabsContent>
        
        <TabsContent value="stats">
          <StatsTab 
            showAge={showAge}
            setShowAge={setShowAge}
            profileDetails={profileDetails}
            setProfileDetails={setProfileDetails}
          />
        </TabsContent>
        
        <TabsContent value="identity">
          <IdentityTab
            socialLinks={socialLinks}
            setSocialLinks={setSocialLinks}
          />
        </TabsContent>
        
        <TabsContent value="health">
          <HealthTab
            healthInfo={healthInfo}
            setHealthInfo={setHealthInfo}
          />
        </TabsContent>
      </Tabs>
    </div>
  );
};

export default EditProfile;
