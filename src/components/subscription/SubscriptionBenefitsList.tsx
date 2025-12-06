
import React from 'react';
import { CheckCircle } from 'lucide-react';

interface SubscriptionBenefitsListProps {
  benefits?: string[];
  className?: string;
}

const SubscriptionBenefitsList: React.FC<SubscriptionBenefitsListProps> = ({ 
  benefits = [
    'Unlimited profile browsing',
    'AI Connect matching algorithm',
    'Unlimited video calls and rooms',
    'Ad-free experience',
    'Priority support',
    'Advanced filters'
  ],
  className = ''
}) => {
  return (
    <ul className={`space-y-3 mb-6 ${className}`}>
      {benefits.map((feature, index) => (
        <li key={index} className="flex items-center gap-2">
          <CheckCircle className="w-5 h-5 text-[#4CAF50] animate-pulse" />
          <span className="neon-text">{feature}</span>
        </li>
      ))}
    </ul>
  );
};

export default SubscriptionBenefitsList;
