#!/bin/sh

numb='1929'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 3.8 --qblur 0.2 --qcomp 0.9 --vbv-init 0.8 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 10 --keyint 210 --lookahead-threads 0 --min-keyint 22 --qp 20 --qpstep 4 --qpmin 0 --qpmax 62 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset placebo --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,1.5,1.6,1.3,3.8,0.2,0.9,0.8,1,1,12,10,210,0,22,20,4,0,62,18,2,1000,1:1,hex,crop,placebo,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"