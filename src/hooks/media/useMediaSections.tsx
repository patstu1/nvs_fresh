
import { useCallback } from 'react';
import { MediaItem, SectionType, MediaVisibility } from '@/types/MediaTypes';

// Default rules for section visibility
export const DEFAULT_SECTION_RULES = {
  grid: {
    allowNsfw: false,
    requireBlur: false,
    defaultVisibility: 'public' as MediaVisibility
  },
  connect: {
    allowNsfw: false,
    requireBlur: false,
    defaultVisibility: 'public' as MediaVisibility
  },
  live: {
    allowNsfw: false,
    requireBlur: false,
    defaultVisibility: 'public' as MediaVisibility
  },
  now: {
    allowNsfw: true,
    requireBlur: true,
    defaultVisibility: 'anonymous' as MediaVisibility
  }
};

export const useMediaSections = (
  publicAlbum: MediaItem[],
  privateAlbum: MediaItem[],
  anonymousAlbum: MediaItem[]
) => {
  /**
   * Get media for a specific section based on visibility rules
   */
  const getMediaForSection = useCallback(
    (section: SectionType): MediaItem[] => {
      switch (section) {
        case 'grid':
        case 'connect':
        case 'live':
          // These sections show only public, non-NSFW content
          return publicAlbum.filter(item => !item.isNsfw);
        case 'now':
          // NOW section shows anonymous content + NSFW public content
          return [
            ...anonymousAlbum,
            ...publicAlbum.filter(item => item.isNsfw),
            ...privateAlbum.filter(item => item.isNsfw)
          ];
        default:
          return [];
      }
    },
    [publicAlbum, privateAlbum, anonymousAlbum]
  );

  return {
    getMediaForSection,
    sectionRules: DEFAULT_SECTION_RULES
  };
};
