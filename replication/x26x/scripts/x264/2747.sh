#!/bin/sh

numb='2748'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 0.8 --qblur 0.2 --qcomp 0.9 --vbv-init 0.2 --aq-mode 1 --b-adapt 2 --bframes 16 --crf 20 --keyint 220 --lookahead-threads 4 --min-keyint 25 --qp 40 --qpstep 5 --qpmin 3 --qpmax 64 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset superfast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.1,1.3,0.8,0.2,0.9,0.2,1,2,16,20,220,4,25,40,5,3,64,18,6,2000,1:1,hex,crop,superfast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"