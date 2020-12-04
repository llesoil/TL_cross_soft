#!/bin/sh

numb='454'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 1.2 --qblur 0.3 --qcomp 0.6 --vbv-init 0.1 --aq-mode 2 --b-adapt 0 --bframes 4 --crf 10 --keyint 250 --lookahead-threads 3 --min-keyint 24 --qp 40 --qpstep 4 --qpmin 4 --qpmax 63 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset faster --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,3.0,1.3,1.0,1.2,0.3,0.6,0.1,2,0,4,10,250,3,24,40,4,4,63,28,4,2000,1:1,hex,show,faster,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"