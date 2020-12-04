#!/bin/sh

numb='1374'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 0.8 --qblur 0.2 --qcomp 0.9 --vbv-init 0.2 --aq-mode 2 --b-adapt 2 --bframes 8 --crf 50 --keyint 270 --lookahead-threads 3 --min-keyint 29 --qp 10 --qpstep 5 --qpmin 1 --qpmax 61 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset placebo --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,2.5,1.1,1.4,0.8,0.2,0.9,0.2,2,2,8,50,270,3,29,10,5,1,61,28,3,2000,-1:-1,umh,crop,placebo,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"