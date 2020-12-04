#!/bin/sh

numb='1944'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.0 --psy-rd 1.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.3 --aq-mode 1 --b-adapt 2 --bframes 16 --crf 10 --keyint 210 --lookahead-threads 0 --min-keyint 26 --qp 0 --qpstep 4 --qpmin 1 --qpmax 61 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset faster --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,2.5,1.5,1.0,1.6,0.5,0.8,0.3,1,2,16,10,210,0,26,0,4,1,61,18,4,2000,-2:-2,hex,show,faster,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"