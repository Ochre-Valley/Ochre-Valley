export type Data = {
  directory: playerEntry[];
}

export type playerEntry = {
  ckey: string;
  name: string;
  job: string;
  category: string;
  photo: string | null;
  afk: string;
  state: number;
  antag: string;
}
