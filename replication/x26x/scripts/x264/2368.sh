#!/bin/sh

numb='2369'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.4 --psy-rd 5.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.9 --aq-mode 1 --b-adapt 2 --bframes 10 --crf 40 --keyint 270 --lookahead-threads 0 --min-keyint 23 --qp 0 --qpstep 5 --qpmin 3 --qpmax 66 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset slow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,2.5,1.0,1.4,5.0,0.4,0.8,0.9,1,2,10,40,270,0,23,0,5,3,66,28,1,2000,-2:-2,dia,show,slow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"