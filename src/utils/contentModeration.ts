
// Simple content moderation utility
// This is a basic implementation that could be enhanced with a real AI service

const INAPPROPRIATE_WORDS = [
  'drugs', 'cocaine', 'heroin', 'meth', 'weed', 'marijuana',
  'hookup', 'escort', 'prostitute', 'sex for money',
  // Add more inappropriate terms as needed
];

export interface ModerationResult {
  isFlagged: boolean;
  reason?: string;
  flaggedWords?: string[];
}

/**
 * Analyzes text content for inappropriate material
 * 
 * @param content The text content to analyze
 * @returns ModerationResult object with analysis results
 */
export const moderateContent = (content: string): ModerationResult => {
  if (!content) {
    return { isFlagged: false };
  }

  const lowerContent = content.toLowerCase();
  const flaggedWords = INAPPROPRIATE_WORDS.filter(word => 
    lowerContent.includes(word.toLowerCase())
  );

  if (flaggedWords.length > 0) {
    return {
      isFlagged: true,
      reason: "Message contains prohibited content",
      flaggedWords
    };
  }

  return { isFlagged: false };
};
