// Flutter imports:
import 'package:flutter/material.dart';

const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const buttonBg = Color(0xFF3A3E4A);

const defaultPadding = 16.0;

enum StateRecipes { initial, inProgress, done, error }

enum FileState { create, find, notFound, error, initial, inProgress }

enum ErrorType {
  nessuno,
  nomePiatto,
  descrizione,
  tempoPreparazione,
  porzioni,
  difficolta,
  ingredienti,
  tag,
  passaggi,
  allergie,
  coverImage,
  stepImage,
  stepText,
  generale
}
