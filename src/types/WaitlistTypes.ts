
export type WaitlistStatus = 'pending' | 'approved' | 'early_access';

export interface WaitlistUser {
  id: string;
  email: string;
  username: string;
  status: WaitlistStatus;
  joinedAt: string;
  approvedAt?: string;
  referralCode: string;
  referrals: number;
  location?: string;
}
