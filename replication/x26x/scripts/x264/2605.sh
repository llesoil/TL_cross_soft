#!/bin/sh

numb='2606'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 4.0 --qblur 0.3 --qcomp 0.8 --vbv-init 0.1 --aq-mode 0 --b-adapt 0 --bframes 6 --crf 35 --keyint 300 --lookahead-threads 1 --min-keyint 27 --qp 50 --qpstep 5 --qpmin 0 --qpmax 64 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset placebo --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,3.0,1.5,1.0,4.0,0.3,0.8,0.1,0,0,6,35,300,1,27,50,5,0,64,18,2,2000,-1:-1,dia,crop,placebo,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"