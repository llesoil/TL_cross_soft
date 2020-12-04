#!/bin/sh

numb='2727'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.0 --psy-rd 2.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.2 --aq-mode 1 --b-adapt 2 --bframes 16 --crf 20 --keyint 300 --lookahead-threads 0 --min-keyint 27 --qp 50 --qpstep 4 --qpmin 1 --qpmax 62 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset faster --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,1.5,1.4,1.0,2.8,0.3,0.7,0.2,1,2,16,20,300,0,27,50,4,1,62,38,2,1000,1:1,hex,crop,faster,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"