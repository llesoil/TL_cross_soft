#!/bin/sh

numb='1485'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 4.2 --qblur 0.4 --qcomp 0.9 --vbv-init 0.5 --aq-mode 1 --b-adapt 1 --bframes 10 --crf 35 --keyint 230 --lookahead-threads 3 --min-keyint 29 --qp 20 --qpstep 3 --qpmin 4 --qpmax 66 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset slower --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,3.0,1.5,1.3,4.2,0.4,0.9,0.5,1,1,10,35,230,3,29,20,3,4,66,38,2,2000,-1:-1,hex,show,slower,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"