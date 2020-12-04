#!/bin/sh

numb='2323'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 0.4 --qblur 0.6 --qcomp 0.8 --vbv-init 0.2 --aq-mode 0 --b-adapt 2 --bframes 4 --crf 50 --keyint 300 --lookahead-threads 1 --min-keyint 26 --qp 0 --qpstep 5 --qpmin 2 --qpmax 64 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset placebo --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,0.0,1.3,1.2,0.4,0.6,0.8,0.2,0,2,4,50,300,1,26,0,5,2,64,28,6,2000,-1:-1,umh,crop,placebo,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"