#!/bin/sh

numb='248'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.4 --psy-rd 2.6 --qblur 0.6 --qcomp 0.9 --vbv-init 0.8 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 15 --keyint 300 --lookahead-threads 3 --min-keyint 26 --qp 20 --qpstep 4 --qpmin 1 --qpmax 62 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset medium --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,0.5,1.5,1.4,2.6,0.6,0.9,0.8,2,2,2,15,300,3,26,20,4,1,62,28,4,1000,-1:-1,hex,show,medium,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"