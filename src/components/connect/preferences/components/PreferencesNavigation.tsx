
import React from 'react';
import { TabsList, TabsTrigger } from '@/components/ui/tabs';

interface PreferencesNavigationProps {
  activeTab: string;
}

export const PreferencesNavigation: React.FC<PreferencesNavigationProps> = ({ activeTab }) => {
  return (
    <TabsList className="grid grid-cols-5 mb-6">
      <TabsTrigger value="identity">Identity</TabsTrigger>
      <TabsTrigger value="sexual">Sexual</TabsTrigger>
      <TabsTrigger value="personality">Personality</TabsTrigger>
      <TabsTrigger value="values">Values</TabsTrigger>
      <TabsTrigger value="social">Social</TabsTrigger>
    </TabsList>
  );
};
