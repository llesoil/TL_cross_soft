#!/bin/sh

numb='596'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.2 --psy-rd 3.4 --qblur 0.5 --qcomp 0.9 --vbv-init 0.8 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 10 --keyint 230 --lookahead-threads 3 --min-keyint 27 --qp 40 --qpstep 4 --qpmin 0 --qpmax 60 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset placebo --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,1.5,1.1,1.2,3.4,0.5,0.9,0.8,0,0,8,10,230,3,27,40,4,0,60,38,2,1000,-2:-2,hex,crop,placebo,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"