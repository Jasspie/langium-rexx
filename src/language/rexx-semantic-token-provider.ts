import * as ast from "./generated/ast.js";
import { SemanticTokenTypes } from "vscode-languageserver";
import {
  AbstractSemanticTokenProvider,
  SemanticTokenAcceptor,
} from "langium/lsp";
import { AstNode } from "langium";

export class RexxSemanticTokenProvider extends AbstractSemanticTokenProvider {
  protected highlightElement(
    node: AstNode,
    acceptor: SemanticTokenAcceptor
  ): void {
    if (ast.isLiteralExpression(node)) {
      acceptor({
        node,
        property: "value",
        type: SemanticTokenTypes.string,
      });
    } else if (ast.isHexLiteralExpression(node)) {
      acceptor({
        node,
        property: "value",
        type: SemanticTokenTypes.string,
      });
    } else if (ast.isBinLiteralExpression(node)) {
      acceptor({
        node,
        property: "value",
        type: SemanticTokenTypes.string,
      });
    } else if (ast.isHexStringWithTextExpression(node)) {
      acceptor({
        node,
        property: "hexValue",
        type: SemanticTokenTypes.string,
      });
      acceptor({
        node,
        property: "textValue",
        type: SemanticTokenTypes.string,
      });
    } else if (ast.isBinStringWithTextExpression(node)) {
      acceptor({
        node,
        property: "binValue",
        type: SemanticTokenTypes.string,
      });
      acceptor({
        node,
        property: "textValue",
        type: SemanticTokenTypes.string,
      });
    } else if (ast.isNumberExpression(node)) {
      acceptor({
        node,
        property: "value",
        type: SemanticTokenTypes.number,
      });
    } else if (ast.isConstantExpression(node)) {
      acceptor({
        node,
        property: "value",
        type: SemanticTokenTypes.type,
      });
    } else if (ast.isSimpleVariable(node)) {
      acceptor({
        node,
        property: "name",
        type: SemanticTokenTypes.variable,
      });
    } else if (ast.isSpecialVariable(node)) {
      acceptor({
        node,
        property: "name",
        type: SemanticTokenTypes.variable,
      });
    } else if (ast.isCompoundVariable(node)) {
      acceptor({
        node,
        property: "stem",
        type: SemanticTokenTypes.variable,
      });
      acceptor({
        node,
        property: "tail",
        type: SemanticTokenTypes.variable,
      });
    } else if (ast.isFunctionCallExpression(node)) {
      acceptor({
        node,
        property: "name",
        type: SemanticTokenTypes.function,
      });
    } else if (ast.isLabel(node)) {
      acceptor({
        node,
        property: "name",
        type: SemanticTokenTypes.namespace,
      });
    } else if (ast.isTemplateList(node)) {
      acceptor({
        node,
        property: "items",
        type: SemanticTokenTypes.variable,
      });
    } else if (ast.isParseVar(node)) {
      acceptor({
        node,
        property: "variable",
        type: SemanticTokenTypes.variable,
      });
    }
  }
}
