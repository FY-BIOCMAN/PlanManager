export interface TaskItem { id: string; parentId: string | null; title: string; startDate: number; endDate: number; priority: number; isCompleted: boolean; }
export const PriorityColor = { 1: "#4CAF50", 2: "#FF9800", 3: "#F44336" };
