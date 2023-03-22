using System.IO;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class Question8 : MonoBehaviour
{
    [Tooltip("Input file of the question.")]
    public TextAsset inputFile;
    [Tooltip("List of tree prefab in order smallest to tallest.")]
    public List<GameObject> treePrefabs;

    // Init variables, to store the width and length of the forest, meaning the number of lines and the character count per line in the input file.
    private int forestLength;
    private int forestWidth;

    // Make a list to hold the rays.
    private List<Ray> raycasts = new List<Ray>();

    // Store the list of occluding trees in a list.
    private List<String> answerList = new List<String>();

    void Start()
    {
        // Get path to input file.
        string input_path = AssetDatabase.GetAssetPath(inputFile);
        ProcessInput(input_path);

        // in case the forest isn't a square, we use the longest side's length in order to still cover the whole forest with raycasts in a single passage.
        int longest_length = Math.Max(forestLength, forestWidth);
        GenerateRaycasts(treePrefabs.Count, longest_length);

        // Iterate over the rays.
        for (int i = 0; i < raycasts.Count; i++)
        {
            // Init the variable that will be populated if something connects with the raycast. It'll hold what connected.
            RaycastHit hit;

            // If the ray connects:
            if (Physics.Raycast(raycasts[i], out hit))
            {
                // Store the name of the tree it collided with.
                string current_tree_name = hit.transform.gameObject.name;
                // Check if the hit tree is already recorded.
                if (!answerList.Contains(current_tree_name))
                {
                    // If not, get the distance.
                    float tree_depth = hit.distance;
                    // Make the target red so as to have a visual aid.
                    // Get the Renderer component from the tree.
                    var tree_renderer = hit.transform.GetComponent<Renderer>();
                    tree_renderer.material.SetColor("_Color", Color.red);

                    // Append the tree's name to the list.
                    answerList.Add(current_tree_name);
                } else
                {
                    // Else everything's already been computed for this tree so we don't need to do anything.
                }
            }
            // If the ray doesn't connect we do not need to do anything.
        };

        Debug.LogFormat("{0} trees can be seen from outside this forest.", answerList.Count);

        int[] answer = TreeScenicScoreComputer();

        Debug.LogFormat("Tree ID: {0}, has a scenic score of: {1}.", answer[0], answer[1]);
    }

    void ProcessInput(string file_path)
    {
        // Instantiate a reader with the file.
        StreamReader text = new StreamReader(file_path);

        // Keep track of the line count.
        int line_n = 0;

        // Iterate over the text file untill the EndOfStream variable turns True.
        while (!text.EndOfStream)
        {
            // Store the current line in a variable.
            string line = text.ReadLine();

            // Iterate over the characters in the string, which represent the height of each tree in a line.
            for (int i = 0; i < line.Length; i++)
            {
                // Get the height of the tree in int form from Char.
                int Height = (int)Char.GetNumericValue(line[i]);
                // Use this height as index to fetch the correct prefab and instanciate it.
                GameObject tree_object = Instantiate<GameObject>(treePrefabs[Height].gameObject, new Vector3(line_n, treePrefabs[Height].gameObject.transform.position.y, i), Quaternion.identity);
                // Give an ID to the object for ease of identification when checking if it's already been counted or not later.
                tree_object.name = line_n.ToString() + "_" + i.ToString();

                // Move the tree under it's correct parent folder.
                tree_object.transform.SetParent(transform, false);
            }

            line_n += 1;

            // Store the forest width, this will run each line but isfineyknow...
            forestWidth = line.Length;
        }
        // Once done, close the file reader to liberate the memory.
        text.Close();

        // Store the forest length.
        forestLength = line_n;
    }

    void GenerateRaycasts(int ray_per_row, int length)
    {
        // Iterate over the rows.
        for (int i = 0; i < length; i++)
        {
            // For each possible tree height:
            for (int h = 0; h < ray_per_row; h++)
            {
                // Create a ray at that height going toward the forest. we target the center of the trees, the minimum size tree is 2 so the ray is cast from height 1, then +2 for each successive height. Hence 1+2*h.
                raycasts.Add(new Ray(new Vector3(i, 1 + 2 * h, -1), transform.forward));
                // We can use the same row iteration to create the raycasts from all the other sides of the forest.
                raycasts.Add(new Ray(new Vector3(-1, 1 + 2 * h, i), transform.right));
                raycasts.Add(new Ray(new Vector3(i, 1 + 2 * h, length + 1), -transform.forward));
                raycasts.Add(new Ray(new Vector3(length + 1, 1 + 2 * h, i), -transform.right));
            }
        }
    }

    int[] TreeScenicScoreComputer()
    {
        // Init the answer variables.
        int scenic_score = 1;
        int[] answer = new int[2] {-1, 0};
        // Store the colour of the best trees so that we can give them their correct colour back if the best changes.
        Color previous_best_colour = Color.green;

        // Iterate over the trees.
        for (int tree_index = 0; tree_index < transform.childCount; tree_index++)
        {
            // Store the transform and the name of the current tree.
            Transform tree = transform.GetChild(tree_index);
            string current_tree_name = tree.name;
            // Split it to get it's coordinates.
            string[] current_tree_position = current_tree_name.Split('_');
            // Store each coordinate in variables for ease of access as ints.
            int current_tree_row = Int16.Parse(current_tree_position[0]);
            int current_tree_column = Int16.Parse(current_tree_position[1]);

            // Init a list of raycasts
            List<Ray> scenic_raycasts = new List<Ray>();
            // Fill it with 4 raycasts, fired from each side at the top of the tree toward each cardinal directions.
            scenic_raycasts.Add(new Ray(new Vector3(tree.position.x, tree.localScale.y-1, tree.position.z + 0.49f), transform.forward));
            scenic_raycasts.Add(new Ray(new Vector3(tree.position.x + 0.49f, tree.localScale.y-1, tree.position.z), transform.right));
            scenic_raycasts.Add(new Ray(new Vector3(tree.position.x, tree.localScale.y-1, tree.position.z - 0.49f), -transform.forward));
            scenic_raycasts.Add(new Ray(new Vector3(tree.position.x - 0.49f, tree.localScale.y-1, tree.position.z), -transform.right));

            // Iterate over the rays.
            for (int i = 0; i < scenic_raycasts.Count; i++)
            {
                // Init the variable that will be populated if something connects with the raycast. It'll hold what connected.
                RaycastHit hit;

                // If the ray connects:
                if (Physics.Raycast(scenic_raycasts[i], out hit))
                {
                    // Store the coordinates of the tree it collided with.
                    string hit_tree_name = hit.transform.gameObject.name;
                    string[] hit_tree_position = hit_tree_name.Split('_');
                    int hit_tree_row = Int16.Parse(hit_tree_position[0]);
                    int hit_tree_column = Int16.Parse(hit_tree_position[1]);

                    // Take the difference between the current_tree coordinates and the hit_tree coordinates, since rays only go up, left, down and right, one of these differences will be 0.
                    // To cover for all possible ray directions, we add both together and take the absolute value of the result.
                    int difference = (hit_tree_row - current_tree_row) + (hit_tree_column - current_tree_column);
                    scenic_score *= Math.Abs(difference);
                }
                // If the ray doesn't connect:
                else
                {
                    // Then we need to count the number of trees between it and one the border.
                    switch (i)
                    {
                        // forward border.
                        case 0:
                            scenic_score *= Math.Max(1, ((forestWidth - 1) - current_tree_column));
                            break;
                        // right border.
                        case 1:
                            scenic_score *= Math.Max(1, ((forestLength - 1) - current_tree_row));
                            break;
                        // back border.
                        case 2:
                            scenic_score *= Math.Max(1, current_tree_column);
                            break;
                        // left border.
                        case 3:
                            scenic_score *= Math.Max(1, current_tree_row);
                            break;
                    }
                }
            };
            // Compare the already recorded answer with the new candidate and keep the biggest one. We also colour the best tree in green and if needed, recolour a previously best tree in white.
            if (scenic_score > answer[1])
            {
                // If a "best tree" title has already been attributed:
                if (answer[0] > -1)
                {
                    // Use the recorded data to turn it back to its original colour.
                    var prev_tree_renderer = transform.GetChild(answer[0]).GetComponent<Renderer>();
                    prev_tree_renderer.material.SetColor("_Color", previous_best_colour);
                }
                // Save the colour of the new best tree.
                var tree_renderer = tree.GetComponent<Renderer>();
                previous_best_colour = tree_renderer.material.color;
                // And make this new best tree green.
                tree_renderer.material.SetColor("_Color", Color.green);
                // Save its index and score.
                answer[0] = tree_index;
                answer[1] = scenic_score;
            }
            // Reset the score for the next tree.
            scenic_score = 1;
        }
        return answer;
    }
}