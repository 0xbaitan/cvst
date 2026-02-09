import z from "zod";

enum Months {
  January = 1,
  February,
  March,
  April,
  May,
  June,
  July,
  August,
  September,
  October,
  November,
  December,
}

export const DateSchema = z.object({
  year: z.number().int().min(1900).max(2100).nonoptional(),
  month: z
    .union([z.number().int().min(1).max(12), z.enum(Months)])
    .nonoptional(),
  day: z.number().int().min(1).max(31).nonoptional(),
});
