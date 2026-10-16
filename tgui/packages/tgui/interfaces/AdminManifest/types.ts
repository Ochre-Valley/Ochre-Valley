export type Data = {
  directory: playerEntry[];
};

export type playerEntry = {
  ckey: string;
  name: string;
  job: string;
  category: string;
  photo: string | null;
  afk: string;
  state: number;
  antag: string;
};

export type playerEntrySortableKey = keyof {
  [K in keyof playerEntry as playerEntry[K] extends string ? K : never]: string;
};
