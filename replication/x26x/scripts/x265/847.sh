#!/bin/sh

numb='848'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 1.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.6 --aq-mode 0 --b-adapt 2 --bframes 4 --crf 0 --keyint 260 --lookahead-threads 4 --min-keyint 22 --qp 50 --qpstep 4 --qpmin 1 --qpmax 69 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset slower --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,0.5,1.2,1.2,1.8,0.5,0.8,0.6,0,2,4,0,260,4,22,50,4,1,69,38,3,2000,-2:-2,hex,crop,slower,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"