import 'dart:async';

class MockAIService {
  /// Simulates an API call to an AI provider
  static Future<String> generateNotes(String level, String fileName) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Return different responses based on the level to demonstrate the "Shift"
    if (level == 'Grade 9-10') {
      return '''
# TL;DR
This document explains how plants make food using sunlight. It's like a recipe where the ingredients are water, air, and light!

# Key Terms
**Photosynthesis**: The process plants use to make food.
**Chlorophyll**: The green stuff in leaves that catches sunlight.

# Summary
Plants are amazing! They take carbon dioxide from the air and water from the ground. Using sunlight, they turn these into sugar (food) and oxygen (which we breathe).

# Check Your Understanding
1. What do plants need to make food?
2. What do plants give us to breathe?

*Keep up the great work! Science is all around you.*
''';
    } else if (level == 'Undergraduate') {
      return '''
# TL;DR
An analysis of the photosynthetic process, focusing on the light-dependent and light-independent reactions and their thermodynamic efficiency.

# Theoretical Framework
Photosynthesis converts light energy into chemical energy. This occurs in two main stages:
1. **Light-Dependent Reactions**: Occur in the thylakoid membranes.
2. **Calvin Cycle**: Occurs in the stroma.

# Critical Thinking
Consider the efficiency of C3 vs. C4 plants. Why might C4 plants have an evolutionary advantage in arid climates?

# Connection to Field Trends
Recent research suggests bio-engineered improvements to RuBisCO could significantly enhance crop yields, addressing global food security.
''';
    } else {
      // PhD / Researcher
      return '''
# TL;DR
A rigorous examination of quantum coherence in the Fenna-Matthews-Olson complex and its implications for photosynthetic efficiency models.

# Methodology & Data Integrity
The text presents spectroscopic data suggesting long-lived quantum coherence at physiological temperatures. However, potential noise artifacts in the 2D electronic spectroscopy data warrant further scrutiny.

# Literature Gaps
While the structural dynamics are well-documented, the functional correlation between excitonic energy transfer and reaction center turnover rates remains under-explored in vivo.

# Synthesis
The proposed mechanism challenges classical hopping models. If validated, this necessitates a revision of the standard excitonic transfer theory in biological systems (\$H = \\sum \\epsilon_i |i\\rangle\\langle i| + \\sum J_{ij} |i\\rangle\\langle j|\$).
''';
    }
  }
}
