# -*- coding: utf-8 -*-
"""
Skrip Training Model AMR untuk PathoPredict

- Memuat dataset AMR (CSV) dengan kolom: user_id, species, genes, antibiotic, label
- Preprocessing: biner gen (menggunakan CountVectorizer), one-hot untuk species & antibiotic
- Melatih RandomForestClassifier
- Menyimpan model ke models/amr_model.pkl
- Menampilkan metrics: precision, recall, f1, dan confusion matrix

Komentar dalam Bahasa Indonesia.
"""
import os
import argparse

import pandas as pd
import joblib

from sklearn.pipeline import Pipeline
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import OneHotEncoder
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, confusion_matrix


def build_pipeline():
    """Bangun pipeline preprocessing + classifier.
    - genes: CountVectorizer (binary=True) dengan tokenizer split koma
    - species: OneHotEncoder
    - antibiotic: OneHotEncoder
    """
    # Tokenizer untuk memisahkan string 'GENE1,GENE2' menjadi list token
    def gene_tokenizer(s: str):
        if s is None:
            return []
        return [t.strip().upper().replace(" ", "_") for t in str(s).split(",") if t and t.strip()]

    preprocess = ColumnTransformer(
        transformers=[
            ("genes", CountVectorizer(tokenizer=gene_tokenizer, lowercase=False, binary=True), "genes"),
            ("species", OneHotEncoder(handle_unknown="ignore"), ["species"]),
            ("antibiotic", OneHotEncoder(handle_unknown="ignore"), ["antibiotic"]),
        ],
        remainder="drop",
    )

    clf = RandomForestClassifier(n_estimators=200, max_depth=None, random_state=42, n_jobs=-1)

    pipeline = Pipeline([
        ("preprocess", preprocess),
        ("clf", clf),
    ])
    return pipeline


def main(input_csv: str, output_model: str = "models/amr_model.pkl"):
    # Muat dataset
    df = pd.read_csv(input_csv)
    # Pastikan kolom yang dibutuhkan ada
    for col in ["species", "genes", "antibiotic", "label"]:
        if col not in df.columns:
            raise ValueError(f"Kolom '{col}' tidak ditemukan di dataset.")

    X = df[["genes", "species", "antibiotic"]].copy()
    y = df["label"].astype(int)

    X_train, X_test, y_train, y_test = train_test_split(X, y, stratify=y, test_size=0.25, random_state=42)

    pipeline = build_pipeline()
    pipeline.fit(X_train, y_train)

    # Evaluasi
    y_pred = pipeline.predict(X_test)
    print("=== Classification Report ===")
    print(classification_report(y_test, y_pred, digits=3))
    print("=== Confusion Matrix ===")
    print(confusion_matrix(y_test, y_pred))

    # Simpan model
    os.makedirs(os.path.dirname(output_model), exist_ok=True)
    joblib.dump(pipeline, output_model)
    print(f"Model disimpan ke: {output_model}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Train AMR model untuk PathoPredict")
    parser.add_argument("--input", type=str, default="data/amr_dataset_sample.csv", help="Path ke CSV dataset AMR")
    parser.add_argument("--output", type=str, default="models/amr_model.pkl", help="Path output model .pkl")
    args = parser.parse_args()

    main(input_csv=args.input, output_model=args.output)