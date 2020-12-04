#!/bin/sh

numb='1596'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 3.0 --qblur 0.3 --qcomp 0.8 --vbv-init 0.5 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 5 --keyint 260 --lookahead-threads 4 --min-keyint 26 --qp 20 --qpstep 5 --qpmin 3 --qpmax 64 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset superfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,0.0,1.0,1.4,3.0,0.3,0.8,0.5,3,2,0,5,260,4,26,20,5,3,64,28,3,1000,-1:-1,dia,show,superfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"