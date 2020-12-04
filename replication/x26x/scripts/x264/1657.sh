#!/bin/sh

numb='1658'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 4.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.6 --aq-mode 1 --b-adapt 2 --bframes 8 --crf 25 --keyint 300 --lookahead-threads 3 --min-keyint 24 --qp 20 --qpstep 5 --qpmin 4 --qpmax 65 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset slower --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,2.0,1.6,1.2,4.8,0.4,0.6,0.6,1,2,8,25,300,3,24,20,5,4,65,28,5,2000,1:1,dia,crop,slower,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"