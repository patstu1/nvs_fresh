import React, { useState } from 'react';
import { Routes, Route, useNavigate } from 'react-router-dom';
import ProfileView from '../components/ProfileView';
import ChatView from '../components/ChatView';
import RoomsView from '../components/RoomsView';
import FavoritesView from '../components/FavoritesView';
import SearchView from '../components/SearchView';
import MapView from '../components/MapView';
import GridView from '../components/GridView';
import YoView from '../components/YoView';
import OnboardingView from '../components/OnboardingView';
import ProfileSetupView from '../components/ProfileSetupView';
import AuthForm from '../components/auth/AuthForm';
import DeploymentReadyCheck from '../components/DeploymentReadyCheck';
import Index from '../pages/Index';
import ConnectStatsView from '../components/connect/ConnectStatsView';
import { toast } from '@/hooks/use-toast';
import { analytics } from '@/services/analytics';
import { TabType } from '@/types/TabTypes';
import ConnectDashboard from '../components/connect/ConnectDashboard';

const AppRoutes: React.FC = () => {
  const navigate = useNavigate();
  const [email, setEmail] = useState<string>('');
  const [password, setPassword] = useState<string>('');
  const [fullName, setFullName] = useState<string>('');
  const [isLoading, setIsLoading] = useState<boolean>(false);
  const [activeTab, setActiveTab] = useState<string>('signin');

  // Mock functions to handle profile and interaction clicks
  const handleProfileClick = (id: string) => {
    analytics.trackProfileView(id);
    navigate(`/profile/${id}`);
  };

  const handleYoSend = (id: string) => {
    analytics.trackYoSent(id);
    toast({
      title: "YO Sent!",
      description: `You sent a YO to user ${id}`,
    });
  };

  // Mock auth handlers
  const handleSignIn = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    // Mock sign in logic
    setTimeout(() => {
      setIsLoading(false);
      toast({
        title: "Signed in",
        description: "Welcome back to YO BRO!",
      });
      navigate('/');
    }, 1000);
  };

  const handleSignUp = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    // Mock sign up logic
    setTimeout(() => {
      setIsLoading(false);
      toast({
        title: "Account created",
        description: "Welcome to YO BRO!",
      });
      navigate('/onboarding');
    }, 1000);
  };

  // Use Index component for all main tabs to ensure the BottomNavBar is always visible
  return (
    <Routes>
      <Route path="/" element={<Index initialTab="grid" />} />
      <Route path="/grid" element={<Index initialTab="grid" />} />
      <Route path="/map" element={<Index initialTab="map" />} />
      <Route path="/rooms" element={<Index initialTab="rooms" />} />
      <Route path="/connect" element={<Index initialTab="connect" />} />
      <Route path="/yo" element={<Index initialTab="yo" />} />
      <Route path="/favorites" element={<Index initialTab="favorites" />} />
      <Route path="/messages" element={<Index initialTab="messages" />} />
      <Route path="/search" element={<Index initialTab="search" />} />
      
      {/* Other routes that don't need bottom navigation */}
      <Route path="/profile/:id" element={<ProfileView />} />
      <Route path="/chat/:id" element={<ChatView />} />
      <Route path="/onboarding" element={<OnboardingView />} />
      <Route path="/profile-setup" element={<ProfileSetupView />} />
      <Route path="/auth" element={
        <AuthForm 
          activeTab={activeTab as 'signin' | 'signup'}
          setActiveTab={setActiveTab}
          isLoading={isLoading}
          handleSignIn={handleSignIn}
          handleSignUp={handleSignUp}
          email={email}
          setEmail={setEmail}
          password={password}
          setPassword={setPassword}
          fullName={fullName}
          setFullName={setFullName}
        />
      } />
      <Route path="/deployment-ready" element={<DeploymentReadyCheck />} />
      <Route path="/connect-dashboard" element={<ConnectDashboard />} />
      <Route path="/connect-stats" element={<ConnectStatsView />} />
    </Routes>
  );
};

export default AppRoutes;
