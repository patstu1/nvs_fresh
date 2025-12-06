
export interface Question {
  id: string;
  text: string;
  options: string[];
  allowMultiple?: boolean;
  category?: string;
  importance?: 'low' | 'medium' | 'high';
}

export interface QuestionnaireProps {
  onComplete: (answers: Record<string, string | string[]>) => void;
  onSkip?: () => void;
  autoStart?: boolean;
  initialQuestionIndex?: number;
  persistenceKey?: string;
}

export interface QuestionnaireAnswers {
  [questionId: string]: string | string[];
}

export interface QuestionDisplayProps {
  question: Question;
  selectedOptions: string[];
  onOptionClick: (option: string) => void;
}

export interface QuestionnaireProgressProps {
  currentQuestionIndex: number;
  totalQuestions: number;
}
