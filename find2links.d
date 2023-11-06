import std.stdio;
import std.process;
import std.array; //to use str.split("\n");
import std.path; //2023-11-05 19:48:44 - baseName()
import std.file;


const APP_NAME = "Find2Links";
void main(string [] args)
{

    writeln(APP_NAME);

    string destination = "./dest";
 
    auto ls = executeShell("find /usr/share/hydrogen -iname \"*kick*\" ");
    if (ls.status != 0) 
    {
        writeln("Failed to retrieve file listing");    
    }
    else
    {
        string [] lines = ls.output.split("\n");
        foreach( line ; lines )
        {
            string filename = line;
            string basename = baseName(line);
            string destfilename =  destination~"/"~basename;
            writeln("symlink("~filename~","~destfilename~"); ");
            if( file.exists(destfile) )
            {
                writeln("Aouch le fichier existe déjà");
            }else
            {
                auto result = std.file.symlink(filename, destfile);
                writeln("création :",result )                ;
            }
        }
    }

}