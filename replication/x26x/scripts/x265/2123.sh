#!/bin/sh

numb='2124'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.4 --psy-rd 3.8 --qblur 0.2 --qcomp 0.9 --vbv-init 0.5 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 5 --keyint 260 --lookahead-threads 0 --min-keyint 25 --qp 20 --qpstep 4 --qpmin 0 --qpmax 60 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset veryslow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,2.5,1.4,1.4,3.8,0.2,0.9,0.5,1,1,12,5,260,0,25,20,4,0,60,38,1,2000,-2:-2,umh,crop,veryslow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"