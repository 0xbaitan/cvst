import z from "zod";
import { DateSchema } from "../helpers/date";

export const ExperienceSchema = z.array(
  z.object({
    title: z.string().min(1),
    company: z.string().min(1),
    location: z.string().optional(),
    "start-date": DateSchema,
    "end-date": z.union([DateSchema, z.literal("Present")]),
    activities: z.array(z.string()).default([]),
  }),
);
