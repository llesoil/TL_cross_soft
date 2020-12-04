#!/bin/sh

numb='2744'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 0.2 --qblur 0.4 --qcomp 0.8 --vbv-init 0.0 --aq-mode 0 --b-adapt 0 --bframes 6 --crf 5 --keyint 230 --lookahead-threads 4 --min-keyint 30 --qp 50 --qpstep 3 --qpmin 0 --qpmax 66 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset slower --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,1.5,1.1,1.4,0.2,0.4,0.8,0.0,0,0,6,5,230,4,30,50,3,0,66,38,3,1000,-2:-2,umh,show,slower,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"