#!/bin/sh

numb='1214'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.4 --psy-rd 3.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.1 --aq-mode 0 --b-adapt 2 --bframes 10 --crf 25 --keyint 270 --lookahead-threads 2 --min-keyint 26 --qp 20 --qpstep 5 --qpmin 1 --qpmax 65 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset fast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,2.5,1.6,1.4,3.0,0.4,0.8,0.1,0,2,10,25,270,2,26,20,5,1,65,28,3,1000,1:1,hex,crop,fast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"