
import React, { useCallback } from 'react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Mail, Lock, User, UserPlus } from 'lucide-react';

interface SignUpFormProps {
  email: string;
  setEmail: (email: string) => void;
  password: string;
  setPassword: (password: string) => void;
  fullName: string;
  setFullName: (fullName: string) => void;
  isLoading: boolean;
  onSubmit: (e: React.FormEvent) => Promise<void>;
}

// Create the icon component outside
const SignUpIcon = () => <UserPlus className="w-4 h-4" />;

// Define a type for the component with Icon property
interface SignUpFormWithIcon extends React.FC<SignUpFormProps> {
  Icon: typeof SignUpIcon;
}

const SignUpForm: React.FC<SignUpFormProps> = ({
  email,
  setEmail,
  password,
  setPassword,
  fullName,
  setFullName,
  isLoading,
  onSubmit
}) => {
  const handleEmailChange = useCallback((e: React.ChangeEvent<HTMLInputElement>) => {
    setEmail(e.target.value);
  }, [setEmail]);
  
  const handlePasswordChange = useCallback((e: React.ChangeEvent<HTMLInputElement>) => {
    setPassword(e.target.value);
  }, [setPassword]);
  
  const handleFullNameChange = useCallback((e: React.ChangeEvent<HTMLInputElement>) => {
    setFullName(e.target.value);
  }, [setFullName]);

  return (
    <form onSubmit={onSubmit} className="space-y-4">
      <div className="space-y-2">
        <Label htmlFor="fullName" className="text-[#E6FFF4]">Full Name</Label>
        <div className="relative">
          <User className="absolute left-3 top-2.5 h-5 w-5 text-[#C2FFE6]/70" />
          <Input
            id="fullName"
            type="text"
            placeholder="John Doe"
            value={fullName}
            onChange={handleFullNameChange}
            required
            className="pl-10 bg-black border-[#C2FFE6]/30 text-[#E6FFF4]"
          />
        </div>
      </div>
      
      <div className="space-y-2">
        <Label htmlFor="signupEmail" className="text-[#E6FFF4]">Email</Label>
        <div className="relative">
          <Mail className="absolute left-3 top-2.5 h-5 w-5 text-[#C2FFE6]/70" />
          <Input
            id="signupEmail"
            type="email"
            placeholder="hello@example.com"
            value={email}
            onChange={handleEmailChange}
            required
            className="pl-10 bg-black border-[#C2FFE6]/30 text-[#E6FFF4]"
          />
        </div>
      </div>
      
      <div className="space-y-2">
        <Label htmlFor="signupPassword" className="text-[#E6FFF4]">Password</Label>
        <div className="relative">
          <Lock className="absolute left-3 top-2.5 h-5 w-5 text-[#C2FFE6]/70" />
          <Input
            id="signupPassword"
            type="password"
            placeholder="••••••••"
            value={password}
            onChange={handlePasswordChange}
            required
            className="pl-10 bg-black border-[#C2FFE6]/30 text-[#E6FFF4]"
          />
        </div>
      </div>
      
      <Button 
        type="submit" 
        className="w-full bg-[#C2FFE6] text-black hover:bg-[#C2FFE6]/90" 
        disabled={isLoading}
      >
        {isLoading ? 'Creating Account...' : 'Sign Up'}
      </Button>
    </form>
  );
};

// First create the memoized component
const MemoizedSignUpForm = React.memo(SignUpForm);

// Then create the final component with the Icon property
const EnhancedSignUpForm = MemoizedSignUpForm as unknown as SignUpFormWithIcon;
EnhancedSignUpForm.Icon = SignUpIcon;

export default EnhancedSignUpForm;
