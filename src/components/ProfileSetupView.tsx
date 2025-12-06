
import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Form } from '@/components/ui/form';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { toast } from '@/hooks/use-toast';
import { useUserSession } from '@/hooks/useUserSession';
import PersonalInfoSection from './profile-setup/PersonalInfoSection';
import InterestsSection from './profile-setup/InterestsSection';
import CompatibilitySection from './profile-setup/CompatibilitySection';
import MediaUploadSection from './profile-setup/MediaUploadSection';
import AIMatchingSection from './profile-setup/AIMatchingSection';
import SocialMediaSection from './profile-setup/SocialMediaSection';
import NavigationControls from './profile-setup/NavigationControls';
import CompletionFeedback from './profile-setup/CompletionFeedback';
import { profileFormSchema, ProfileFormValues } from '@/types/ProfileSetupTypes';
import { motion, AnimatePresence } from 'framer-motion';

export const ProfileSetupView: React.FC = () => {
  const [currentSection, setCurrentSection] = useState(0);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isComplete, setIsComplete] = useState(false);
  const { completeProfileSetup } = useUserSession();
  const navigate = useNavigate();

  const form = useForm<ProfileFormValues>({
    resolver: zodResolver(profileFormSchema),
    defaultValues: {
      personalDetails: {
        name: "",
        age: undefined,
        bio: "",
        height: undefined,
        bodyType: "",
        role: "",
        profession: "",
        education: "",
      },
      interests: {
        hobbies: [],
        interests: [],
        favoriteActivities: [],
        music: [],
        movies: [],
      },
      compatibility: {
        wantsKids: false,
        hasKids: false,
        isFamilyOriented: false,
        isDrinker: false,
        isSmoker: false,
        isReligious: false,
        openToLongDistance: false,
        politicalView: "",
        relationshipType: [],
        dealBreakers: [],
      },
      media: {
        profilePictures: [],
        profileVideo: "",
        publicAlbum: [],
        privateAlbum: [],
      },
      socialMedia: {
        instagram: "",
        twitter: "",
        facebook: "",
        linkedin: "",
        other: "",
      },
      allowAiAnalysis: false,
    },
    mode: "onChange"
  });

  const sections = [
    {
      title: "Personal Information",
      component: <PersonalInfoSection />,
    },
    {
      title: "Interests & Hobbies",
      component: <InterestsSection />,
    },
    {
      title: "Compatibility Factors",
      component: <CompatibilitySection />,
    },
    {
      title: "Social Media",
      component: <SocialMediaSection />,
    },
    {
      title: "Profile Media",
      component: <MediaUploadSection />,
    },
    {
      title: "AI Connection Setup",
      component: <AIMatchingSection isProcessing={isSubmitting} onSubmit={onSubmit} />,
    },
  ];

  const nextSection = () => {
    if (currentSection < sections.length - 1) {
      // Validate the current section
      const currentFields = getCurrentSectionFields();
      
      form.trigger(currentFields as any).then(isValid => {
        if (isValid) {
          setCurrentSection(prev => prev + 1);
          window.scrollTo({ top: 0, behavior: 'smooth' });
        } else {
          toast({
            title: "Please complete all required fields",
            description: "Fill in the required information to continue",
            variant: "destructive"
          });
        }
      });
    }
  };

  const previousSection = () => {
    if (currentSection > 0) {
      setCurrentSection(prev => prev - 1);
      window.scrollTo({ top: 0, behavior: 'smooth' });
    }
  };

  function getCurrentSectionFields(): string[] {
    switch (currentSection) {
      case 0:
        return ['personalDetails.name', 'personalDetails.age', 'personalDetails.bio'];
      case 1:
        return ['interests.hobbies', 'interests.interests', 'interests.favoriteActivities'];
      case 2:
        return ['compatibility.relationshipType'];
      case 3:
        return ['socialMedia.instagram', 'socialMedia.twitter', 'socialMedia.facebook'];
      case 4:
        return ['media.profilePictures'];
      case 5:
        return ['allowAiAnalysis'];
      default:
        return [];
    }
  }

  function onSubmit(data?: ProfileFormValues) {
    setIsSubmitting(true);
    
    const formData = data || form.getValues();
    
    // Store the profile data in localStorage for demo purposes
    localStorage.setItem('userProfile', JSON.stringify(formData));
    
    setTimeout(() => {
      console.log("Profile setup complete:", formData);
      
      // Mark profile setup as complete
      completeProfileSetup();
      
      // Show completion state
      setIsSubmitting(false);
      setIsComplete(true);
      
      // Show toast
      toast({
        title: "Profile created successfully!",
        description: "You're ready to start connecting.",
      });
      
      // Navigate to home after brief delay
      setTimeout(() => {
        navigate("/");
      }, 2000);
    }, 1500);
  }

  return (
    <div className="min-h-screen bg-black p-4">
      <div className="container max-w-2xl mx-auto">
        <h1 className="text-3xl font-bold mb-2 text-[#E6FFF4]">Profile Setup</h1>
        <p className="mb-6 text-[#E6FFF4]/80">
          Complete your profile to get better connections
        </p>
        
        <div className="mb-6">
          <div className="flex justify-between mb-2">
            {sections.map((section, index) => (
              <div 
                key={index}
                className={`flex-1 h-2 rounded-full mx-1 transition-colors duration-300 ${
                  index <= currentSection 
                    ? "bg-[#E6FFF4]" 
                    : "bg-[#E6FFF4]/30"
                }`}
              />
            ))}
          </div>
          <h2 className="text-xl font-semibold text-[#E6FFF4]">
            {sections[currentSection].title}
          </h2>
        </div>
        
        <Form {...form}>
          <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
            <AnimatePresence mode="wait">
              <motion.div
                key={currentSection}
                initial={{ opacity: 0, x: 20 }}
                animate={{ opacity: 1, x: 0 }}
                exit={{ opacity: 0, x: -20 }}
                transition={{ duration: 0.3 }}
              >
                {sections[currentSection].component}
              </motion.div>
            </AnimatePresence>
            
            <NavigationControls 
              currentSection={currentSection}
              totalSections={sections.length}
              onNext={nextSection}
              onPrevious={previousSection}
              isLastSection={currentSection === sections.length - 1}
              onSubmit={() => form.handleSubmit(onSubmit)()}
              isValid={!Object.keys(form.formState.errors).length}
            />
          </form>
        </Form>
      </div>
      
      <CompletionFeedback 
        isProcessing={isSubmitting} 
        isComplete={isComplete} 
      />
    </div>
  );
};

export default ProfileSetupView;
