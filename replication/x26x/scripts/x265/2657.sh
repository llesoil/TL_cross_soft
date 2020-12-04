#!/bin/sh

numb='2658'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 0.8 --qblur 0.2 --qcomp 0.9 --vbv-init 0.2 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 45 --keyint 300 --lookahead-threads 4 --min-keyint 26 --qp 50 --qpstep 3 --qpmin 0 --qpmax 62 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset veryslow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,1.0,1.5,1.0,0.8,0.2,0.9,0.2,1,1,12,45,300,4,26,50,3,0,62,28,4,1000,-2:-2,umh,show,veryslow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"