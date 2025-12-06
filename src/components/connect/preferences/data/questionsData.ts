import { Question } from '../types/questionnaireTypes';

export const questionsData: Question[] = [
  {
    id: 'seeking',
    text: 'What are you seeking right now?',
    options: ['Casual Dating', 'Serious Relationship', 'Friendship', 'Networking', 'Just Exploring'],
  },
  {
    id: 'personality',
    text: 'Select traits that best describe your personality',
    options: ['Outgoing', 'Introverted', 'Adventurous', 'Creative', 'Analytical', 'Compassionate', 'Ambitious'],
    allowMultiple: true,
  },
  {
    id: 'interests',
    text: 'What interests would you like to share with others?',
    options: ['Fitness', 'Art & Culture', 'Technology', 'Travel', 'Music', 'Food & Cooking', 'Sports', 'Reading'],
    allowMultiple: true,
  },
  {
    id: 'dealbreakers',
    text: 'What are your relationship dealbreakers?',
    options: ['Smoking', 'Drinking', 'Different Political Views', 'Long Distance', 'Different Life Goals', 'Poor Communication'],
    allowMultiple: true,
  },
  {
    id: 'communication',
    text: 'What is your preferred communication style?',
    options: ['Direct & Straightforward', 'Thoughtful & Reflective', 'Playful & Humorous', 'Deep & Philosophical'],
  },
  {
    id: 'social',
    text: 'In social settings, how do you usually behave?',
    options: ['I\'m the life of the party', 'I prefer small groups', 'I\'m better one-on-one', 'It depends on my mood', 'I prefer to observe'],
  },
  {
    id: 'lifestyle',
    text: 'How would you describe your lifestyle?',
    options: ['Very Active', 'Balanced', 'Relaxed', 'Work-focused', 'Family-oriented', 'Socially-driven'],
  },
  {
    id: 'values',
    text: 'What values are most important to you?',
    options: ['Family', 'Career', 'Personal Growth', 'Helping Others', 'Creativity', 'Stability', 'Adventure', 'Independence'],
    allowMultiple: true,
  },
  {
    id: 'activities',
    text: 'What activities do you enjoy on weekends?',
    options: ['Outdoor Adventures', 'Relaxing at Home', 'Cultural Events', 'Socializing', 'Working on Projects', 'Sports'],
    allowMultiple: true,
  },
  {
    id: 'pets',
    text: 'What is your stance on pets?',
    options: ['Love all pets', 'Cat person', 'Dog person', 'Allergic to pets', 'Not interested in pets'],
  },
  {
    id: 'music',
    text: 'What music genres do you enjoy most?',
    options: ['Pop', 'Rock', 'Hip-Hop', 'Electronic', 'Classical', 'Jazz', 'Country', 'Indie'],
    allowMultiple: true,
  },
  {
    id: 'travel',
    text: 'What is your travel style?',
    options: ['Luxury Traveler', 'Budget Backpacker', 'Adventure Seeker', 'Cultural Explorer', 'Homebody', 'Business Traveler'],
  },
  {
    id: 'food',
    text: 'What are your food preferences?',
    options: ['Foodie/Try Everything', 'Vegetarian/Vegan', 'Health-Conscious', 'Fast Food Lover', 'Home Cook', 'Picky Eater'],
  },
  {
    id: 'timePreference',
    text: 'Are you a morning person or night owl?',
    options: ['Early Bird', 'Night Owl', 'Depends on the Day', 'Balanced'],
  },
  {
    id: 'future',
    text: 'Where do you see yourself in 5 years?',
    options: ['Advancing My Career', 'Starting/Growing a Family', 'Traveling the World', 'Pursuing Education', 'Building Wealth', 'Living Simply'],
  },
  {
    id: 'financialStyle',
    text: 'How would you describe your financial style?',
    options: ['Frugal Saver', 'Balanced', 'Generous Spender', 'Investor', 'Live for Today'],
  },
  {
    id: 'politicalView',
    text: 'How important are political views to you?',
    options: ['Very Important', 'Somewhat Important', 'Not Very Important', 'Not Important At All', 'Prefer Not to Say'],
  },
  {
    id: 'socialMedia',
    text: 'How active are you on social media?',
    options: ['Very Active', 'Moderately Active', 'Minimally Active', 'Not Active', 'No Social Media'],
  },
  {
    id: 'exerciseHabit',
    text: 'What are your exercise habits?',
    options: ['Daily Exercise', 'Several Times a Week', 'Occasional', 'Rarely Exercise', 'Sports Instead of Exercise'],
  },
  {
    id: 'readingHabit',
    text: 'What are your reading habits?',
    options: ['Avid Reader', 'Occasional Reader', 'Audio Book Listener', 'Articles & News Only', 'Not a Reader'],
  }
];
