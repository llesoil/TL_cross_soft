#!/bin/sh

numb='359'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 2.6 --qblur 0.3 --qcomp 0.7 --vbv-init 0.3 --aq-mode 2 --b-adapt 1 --bframes 6 --crf 5 --keyint 200 --lookahead-threads 3 --min-keyint 27 --qp 0 --qpstep 4 --qpmin 1 --qpmax 62 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset slower --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,0.0,1.3,1.4,2.6,0.3,0.7,0.3,2,1,6,5,200,3,27,0,4,1,62,38,5,2000,-2:-2,hex,show,slower,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"