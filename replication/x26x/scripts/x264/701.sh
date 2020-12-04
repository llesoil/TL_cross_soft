#!/bin/sh

numb='702'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 5.0 --qblur 0.6 --qcomp 0.9 --vbv-init 0.6 --aq-mode 1 --b-adapt 2 --bframes 0 --crf 0 --keyint 230 --lookahead-threads 4 --min-keyint 22 --qp 30 --qpstep 3 --qpmin 0 --qpmax 61 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset fast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,1.5,1.6,1.3,5.0,0.6,0.9,0.6,1,2,0,0,230,4,22,30,3,0,61,28,5,2000,-2:-2,dia,show,fast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"