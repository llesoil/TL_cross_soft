#!/bin/sh

numb='3017'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 0.2 --qblur 0.6 --qcomp 0.7 --vbv-init 0.6 --aq-mode 1 --b-adapt 0 --bframes 8 --crf 50 --keyint 290 --lookahead-threads 3 --min-keyint 26 --qp 30 --qpstep 5 --qpmin 2 --qpmax 68 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset slower --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,0.0,1.6,1.0,0.2,0.6,0.7,0.6,1,0,8,50,290,3,26,30,5,2,68,28,2,2000,-2:-2,umh,show,slower,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"