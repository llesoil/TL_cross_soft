#!/bin/sh

numb='1872'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 2.2 --qblur 0.6 --qcomp 0.9 --vbv-init 0.7 --aq-mode 3 --b-adapt 2 --bframes 8 --crf 10 --keyint 290 --lookahead-threads 0 --min-keyint 23 --qp 40 --qpstep 4 --qpmin 4 --qpmax 65 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset slower --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.0,1.0,1.0,2.2,0.6,0.9,0.7,3,2,8,10,290,0,23,40,4,4,65,38,4,2000,-1:-1,dia,show,slower,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"