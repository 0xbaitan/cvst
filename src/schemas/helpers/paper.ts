import z from "zod";

export const PaperSchema = z.enum(["a4", "letter", "legal", "a3"]);
