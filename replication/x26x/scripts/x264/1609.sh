#!/bin/sh

numb='1610'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 1.8 --qblur 0.6 --qcomp 0.7 --vbv-init 0.8 --aq-mode 2 --b-adapt 0 --bframes 10 --crf 40 --keyint 290 --lookahead-threads 4 --min-keyint 29 --qp 40 --qpstep 5 --qpmin 3 --qpmax 60 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset medium --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,0.0,1.2,1.3,1.8,0.6,0.7,0.8,2,0,10,40,290,4,29,40,5,3,60,28,2,1000,1:1,umh,show,medium,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"