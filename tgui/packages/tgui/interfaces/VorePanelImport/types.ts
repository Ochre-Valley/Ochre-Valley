export type ImportData = DesiredData | Record<string, unknown>;

export type Belly = { name: string } & Record<string, string | number | null>;

export type DesiredData = Record<
  string,
  {
    bellies: Belly[];
    soulcatcher?: Record<string, string | number | null>;
    version?: string;
    repo?: string;
  }
>;
