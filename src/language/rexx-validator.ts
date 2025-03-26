import type { ValidationAcceptor, ValidationChecks } from "langium";
import type { RexxAstType } from "./generated/ast.js";
import type { RexxServices } from "./rexx-module.js";

/**
 * Register custom validation checks.
 */
export function registerValidationChecks(services: RexxServices) {
  const registry = services.validation.ValidationRegistry;
  const validator = services.validation.RexxValidator;
  const checks: ValidationChecks<RexxAstType> = {
    Assignment: validator.checkAssignment,
    IfInstruction: validator.checkIfStatement,
  };
  registry.register(checks, validator);
}

/**
 * Implementation of custom validations.
 */
export class RexxValidator {
  /**
   * Checks that an assignment has a valid expression
   */
  checkAssignment(node: any, accept: ValidationAcceptor): void {
    if (!node.expression) {
      accept("error", "Assignment must have an expression.", { node });
    }

    // Check variable name length
    if (node.variable && node.variable.length > 250) {
      accept(
        "error",
        "Variable name exceeds maximum length (250 characters).",
        {
          node,
          property: "variable",
        }
      );
    }
  }

  /**
   * Checks if statements
   */
  checkIfStatement(node: any, accept: ValidationAcceptor): void {
    if (!node.condition) {
      accept("error", "IF statement must have a condition expression.", {
        node,
      });
    }

    if (!node.thenPart) {
      accept("error", "IF statement must have a THEN condition.", { node });
    }
  }
}
